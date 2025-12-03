<?php

declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

return (new Config())
    ->setRiskyAllowed(false)
    ->setRules([
        '@PhpCsFixer' => true,
    ])
    ->setFinder(
        (new Finder())
            ->in(__DIR__)
            ->exclude(['thirdparty'])
            ->name('*.php')
    )
;

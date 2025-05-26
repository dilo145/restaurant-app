<?php

namespace App\Enum;

enum ReservationStatus: string
{
    case PENDING = 'pending';
    case CONFIRMED = 'confirmed';
    case CANCELLED = 'cancelled';
    case COMPLETED = 'completed';

    public function isFinal(): bool
    {
        return in_array($this, [self::CANCELLED, self::COMPLETED]);
    }
}